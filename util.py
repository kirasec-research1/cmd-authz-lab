def compute_total(items, rate):
    total = 0
    for i in items:
        total += i * rate
    return total


def normalize(name):
    return name.strip().lower()


def apply_discount(total, pct):
    return total - (total * pct / 100)
