"""
Jake McLellan
github.com/JrM2628
Written for RITSec RSA Crypto Challenge
Generates RSA private key given p, q

Usage ex: python rsabreak.py 863653476616376575308866344984576466644942572246900013156919 965445304326998194798282228842484732438457170595999523426901 -o private.asn1

CREDIT FOR MOD_INV & EGCD:
https://en.wikibooks.org/wiki/Algorithm_Implementation/Mathematics/Extended_Euclidean_algorithm
https://stackoverflow.com/questions/50053884/use-rsa-public-key-to-generate-private-key-in-openssl
"""
import argparse


def egcd(a, b):
    if a == 0:
        return b, 0, 1
    else:
        g, x, y = egcd(b % a, a)
        return g, y - (b // a) * x, x


def mod_inv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('modular inverse does not exist')
    else:
        return x % m


def gen_exponents(d, p, q):
    e1 = d % (p - 1)
    e2 = d % (q - 1)
    return e1, e2

"""
	Takes in all of the necessary values and then returns an asn1 string that can be used to generate the private key
"""
def gen_asn1(v, n, e, d, p, q, e1, e2, c):
    asn1 = "asn1=SEQUENCE:rsa_key\n\n[rsa_key]\n"
    asn1 += "version=INTEGER:{}\n" \
            "modulus=INTEGER:{}\n" \
            "pubExp=INTEGER:{}\n" \
            "privExp=INTEGER:{}\n" \
            "p=INTEGER:{}\n" \
            "q=INTEGER:{}\n" \
            "e1=INTEGER:{}\n" \
            "e2=INTEGER:{}\n" \
            "coeff=INTEGER:{}"
    asn1 = asn1.format(v, n, e, d, p, q, e1, e2, c)
    return asn1


def write_asn1(asn1outfile, asn1str):
    with open(asn1outfile, "w") as file:
        file.write(asn1str)
        file.close()
    print("[*] ASN.1 written to", asn1outfile)
    print("\n[*] Use OpenSSL to generate the private key using the command: ")
    print("openssl asn1parse -genconf", asn1outfile, "-out private_key.der")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("p", help="Prime p value in RSA function n = p * q", type=int)
    parser.add_argument("q", help="Prime q value in RSA function n = P * q", type=int)
    parser.add_argument("-e", "--pubExp", help="Public exponent (default 65537)", type=int, default=65537)
    parser.add_argument("-o", "--out", action="store",
                        help="Output file where ASN.1 version of private key is written to", type=str)
    args = parser.parse_args()

    public_exponent = args.pubExp
    p = args.p
    q = args.q
    mod = p * q                                                         # also referred to as n

    t = (p-1)*(q-1)
    d = mod_inv(public_exponent, t)                                     # private exponent
    e1, e2 = gen_exponents(d, p, q)
    c = mod_inv(q, p)                                                   # coefficient
    asn1_str = gen_asn1(0, mod, public_exponent, d, p, q, e1, e2, c)
    if args.out:
        write_asn1(args.out, asn1_str)
    else:
        print(asn1_str)


if __name__ == '__main__':
    main()
