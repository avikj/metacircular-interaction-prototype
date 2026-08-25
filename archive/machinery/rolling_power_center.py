"""Rolling-scale implementation of the adaptive valuation center trace."""

from adaptive_valuation_identification import tau
from power_witness_construction import binary_power_chain


def rolling_run(r: int, p: int, k: int):
    power_ops = binary_power_chain(p, k)
    modulus = power_ops[-1].result if power_ops else p
    prefix = 0
    scale = 1
    centers = []
    center_subtractions = []
    scale_multiplications = []
    previous = None
    for ell in range(k):
        for digit in range(p - 1):
            center = modulus - prefix - digit * scale
            centers.append(center)
            if previous is not None and center != previous:
                center_subtractions.append((previous, previous - center, center))
            previous = center
            if tau(r + center, p, k) >= ell + 1:
                prefix += digit * scale
                break
        else:
            prefix += (p - 1) * scale
        if ell + 1 < k:
            nxt = scale * p
            scale_multiplications.append((scale, p, nxt))
            scale = nxt
    return {
        "modulus": modulus,
        "power_ops": power_ops,
        "scale_ops": scale_multiplications,
        "centers": centers,
        "subtractions": center_subtractions,
        "recovered": prefix,
    }
