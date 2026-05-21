import base64
import math
import os
import pathlib
import secrets as sec  # Added alias 'sec' to fix NameError


def isprime(n, k=40):
    if n < 2:
        return False
    for p in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]:
        if n % p == 0:
            return n == p

    s, d = 0, n - 1
    while d % 2 == 0:
        s += 1
        d //= 2

    for _ in range(k):
        a = sec.randbelow(n - 3) + 2
        x = pow(a, d, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(s - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True


def gen256prime():
    lower_bound = 10**255
    upper_bound = (10**256) - 1

    while True:
        n = sec.randbelow(upper_bound - lower_bound) + lower_bound
        if n % 2 == 0:
            n += 1
        if isprime(n):
            return n


def transform_and_encode():
    prime = gen256prime()
    prime_bytes = str(prime).encode("utf-8")
    noise_length = math.ceil(math.log10(prime))
    salt_prefix = os.urandom(noise_length)
    salt_suffix = os.urandom(noise_length)
    mixdata = salt_prefix + prime_bytes + salt_suffix
    first_base64 = base64.b64encode(mixdata)
    fb64out_ = base64.b64encode(first_base64)
    return fb64out_.decode("utf-8"), prime


encres, oprime = transform_and_encode()

print(encres)


def savekey(encres, filename="key.key"):
    script_dir = pathlib.Path(__file__).resolve().parent
    file_path = script_dir / filename

    if isinstance(encres, bytes):
        file_path.write_bytes(encres)
    else:
        file_path.write_text(str(encres), encoding="utf-8")

    print("done")


savekey(encres, filename="key.key")
