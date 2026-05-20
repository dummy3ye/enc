#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STATE_SIZE 16

typedef struct {
  uint8_t state[STATE_SIZE];
} CipherContext;

static void mix_state(uint8_t state[STATE_SIZE]) {
  for (int i = 0; i < STATE_SIZE; i++) {
    state[i] ^=
        (state[(i + 1) % STATE_SIZE] << 3) | (state[(i + 1) % STATE_SIZE] >> 5);
    state[i] = (state[i] + 0x9E) ^ 0x37;
    state[i] ^= (state[(i + STATE_SIZE - 1) % STATE_SIZE] >> 2);
  }
}

static void init_context(CipherContext *ctx, const char *key) {
  memset(ctx->state, 0xAA, STATE_SIZE);
  size_t key_len = strlen(key);
  for (size_t i = 0; i < key_len; i++) {
    ctx->state[i % STATE_SIZE] ^= (uint8_t)key[i];
    mix_state(ctx->state);
  }
  for (int i = 0; i < 4; i++)
    mix_state(ctx->state);
}

static void mutate_state(uint8_t state[STATE_SIZE], uint8_t feedback) {
  for (int i = 0; i < STATE_SIZE; i++) {
    state[i] = (state[i] ^ (feedback + i)) + state[(i + 1) % STATE_SIZE];
  }
  uint8_t first = state[0];
  for (int i = 0; i < STATE_SIZE - 1; i++) {
    state[i] = state[i + 1];
  }
  state[STATE_SIZE - 1] = first ^ feedback;
}

static uint8_t transform_byte(CipherContext *ctx, uint8_t b, int encrypt) {
  uint8_t keystream = ctx->state[0] ^ ctx->state[STATE_SIZE - 1];
  uint8_t out = b ^ keystream;
  uint8_t feedback = encrypt ? out : b;
  mutate_state(ctx->state, feedback);
  return out;
}

static char *load_key_from_file(const char *filename) {
  FILE *f = fopen(filename, "rb");
  if (!f)
    return NULL;
  fseek(f, 0, SEEK_END);
  long size = ftell(f);
  fseek(f, 0, SEEK_SET);
  if (size <= 0) {
    fclose(f);
    return NULL;
  }
  char *key = malloc(size + 1);
  if (!key) {
    fclose(f);
    return NULL;
  }
  size_t read_size = fread(key, 1, size, f);
  key[read_size] = '\0';
  fclose(f);
  while (read_size > 0 &&
         (key[read_size - 1] == '\n' || key[read_size - 1] == '\r' ||
          key[read_size - 1] == ' ')) {
    key[--read_size] = '\0';
  }
  return key;
}

static char *load_input_content(const char *input, size_t *out_len) {
  FILE *f = fopen(input, "rb");
  if (!f)
    return NULL;
  fseek(f, 0, SEEK_END);
  long size = ftell(f);
  fseek(f, 0, SEEK_SET);
  if (size < 0) {
    fclose(f);
    return NULL;
  }
  char *content = malloc(size + 1);
  if (!content) {
    fclose(f);
    return NULL;
  }
  *out_len = fread(content, 1, size, f);
  content[*out_len] = '\0';
  fclose(f);
  return content;
}

static void print_usage() {
  printf("enc - Lightweight Secure CLI Encryption Tool\n\n");
  printf("Usage:\n");
  printf("  enc -e <text|file> [-key \"key\" | -f \"file\"] [-o \"out\"]\n");
  printf("  enc -d <hex|file>  [-key \"key\" | -f \"file\"] [-o \"out\"]\n\n");
  printf("Options:\n");
  printf("  -e <input>    Encrypt plain text or file content.\n");
  printf("  -d <input>    Decrypt hex string or file containing hex.\n");
  printf("  -key <string> Provide the encryption key directly.\n");
  printf("  -f <file>     Load the encryption key from a file.\n");
  printf("  -o <file>     Write output to a file instead of stdout.\n");
  printf("  -h, --help    Show this help message.\n");
}

int main(int argc, char *argv[]) {
  char *input_arg = NULL;
  char *key_str = NULL;
  char *key_file = NULL;
  char *output_file = NULL;
  int mode = 0;

  if (argc == 1) {
    print_usage();
    return 0;
  }

  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
      print_usage();
      return 0;
    } else if (strcmp(argv[i], "-e") == 0 && i + 1 < argc) {
      input_arg = argv[++i];
      mode = 1;
    } else if (strcmp(argv[i], "-d") == 0 && i + 1 < argc) {
      input_arg = argv[++i];
      mode = 2;
    } else if (strcmp(argv[i], "-key") == 0 && i + 1 < argc) {
      key_str = argv[++i];
    } else if (strcmp(argv[i], "-f") == 0 && i + 1 < argc) {
      key_file = argv[++i];
    } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
      output_file = argv[++i];
    }
  }

  if (!input_arg || mode == 0) {
    print_usage();
    return 1;
  }

  size_t input_len = 0;
  char *input_content = load_input_content(input_arg, &input_len);
  if (!input_content) {
    input_content = input_arg;
    input_len = strlen(input_arg);
  }

  char *allocated_key = NULL;
  if (!key_str) {
    if (key_file) {
      allocated_key = load_key_from_file(key_file);
      if (!allocated_key) {
        fprintf(stderr, "Error: Could not read key from file '%s'\n", key_file);
        if (input_content != input_arg)
          free(input_content);
        return 1;
      }
      key_str = allocated_key;
    } else {
      allocated_key = load_key_from_file("key.txt");
      if (!allocated_key) {
        fprintf(stderr, "Error: No key provided and 'key.txt' not found.\n");
        if (input_content != input_arg)
          free(input_content);
        return 1;
      }
      key_str = allocated_key;
    }
  }

  CipherContext ctx;
  init_context(&ctx, key_str);
  if (allocated_key)
    free(allocated_key);

  FILE *out = stdout;
  if (output_file) {
    out = fopen(output_file, "wb");
    if (!out) {
      perror("Failed to open output file");
      if (input_content != input_arg)
        free(input_content);
      return 1;
    }
  }

  if (mode == 1) {
    for (size_t i = 0; i < input_len; i++) {
      uint8_t c = transform_byte(&ctx, (uint8_t)input_content[i], 1);
      fprintf(out, "%02x", c);
    }
    if (!output_file)
      fprintf(out, "\n");
  } else {
    if (input_content != input_arg) {
      while (input_len > 0 && (input_content[input_len - 1] == '\n' ||
                               input_content[input_len - 1] == '\r' ||
                               input_content[input_len - 1] == ' ')) {
        input_content[--input_len] = '\0';
      }
    }
    if (input_len % 2 != 0) {
      fprintf(stderr, "Invalid hexadecimal input length.\n");
      if (output_file)
        fclose(out);
      if (input_content != input_arg)
        free(input_content);
      return 1;
    }
    for (size_t i = 0; i < input_len; i += 2) {
      unsigned int hex_val;
      if (sscanf(&input_content[i], "%02x", &hex_val) != 1) {
        fprintf(stderr, "Invalid hexadecimal input.\n");
        if (output_file)
          fclose(out);
        if (input_content != input_arg)
          free(input_content);
        return 1;
      }
      uint8_t p = transform_byte(&ctx, (uint8_t)hex_val, 0);
      fputc(p, out);
    }
    if (!output_file)
      fputc('\n', out);
  }

  if (output_file)
    fclose(out);
  if (input_content != input_arg)
    free(input_content);
  return 0;
}
