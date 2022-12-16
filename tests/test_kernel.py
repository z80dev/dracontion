import boa

def test_counter_inc():
    k = boa.load("contracts/Kernel.vy")
    counts_module = boa.load("contracts/modules/Counts.vy", k.address)
    counter_policy = boa.load("contracts/policies/Counter.vy", k.address)

    k.executeAction(1, counts_module.address)
    k.executeAction(4, counter_policy.address)

    counter_policy.inc()

    count = counts_module.counts(k.executor())
    assert count == 1
