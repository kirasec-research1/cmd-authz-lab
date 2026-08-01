def compute_total(items, rate):
    total = 0
    for i in items:
        total += i * rate
    return total


def normalize(name):
    return name.strip().lower()
