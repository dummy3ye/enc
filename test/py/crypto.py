import secrets

def is_prime(n, k=40):
    if n < 2: return False
    small_primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
    for p in small_primes:
        if n % p == 0:
            return n == p
            
    s, d = 0, n - 1
    while d % 2 == 0:
        s += 1
        d //= 2
        
    for _ in range(k):
        a = secrets.randbelow(n - 3) + 2
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

def generate_256_digit_prime():
    """Generates an exact 256-digit prime number."""
    lower_bound = 10**255
    upper_bound = (10**256) - 1
    
    while True:
        n = secrets.randbelow(upper_bound - lower_bound) + lower_bound
        if n % 2 == 0:
            n += 1
        if is_prime(n):
            return n

large_prime = generate_256_digit_prime()
print(f"Prime Number ({len(str(large_prime))} digits):\n{large_prime}")

