def test_kernel(project, accounts):
    kernel = project.Kernel.deploy(sender=accounts[0])
    dep_reg = project.DepositRegistry.deploy(kernel.address, sender=accounts[0])
    nft_mgr = project.ERC721TransferManager.deploy(kernel.address, sender=accounts[0])
    xnft_mgr = project.ERC721XManager.deploy(kernel.address, sender=accounts[0])
    counts = project.Counts.deploy(kernel.address, sender=accounts[0])
    counter = project.Counter.deploy(kernel.address, sender=accounts[0])

    kernel.executeAction(1, counts.address, sender=accounts[0])
    kernel.executeAction(1, dep_reg.address, sender=accounts[0])
    kernel.executeAction(1, nft_mgr.address, sender=accounts[0])
    kernel.executeAction(1, xnft_mgr.address, sender=accounts[0])
    kernel.executeAction(4, counter.address, sender=accounts[0])
    lz_nft_bridge = project.LZNFTBridge.deploy("0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675", kernel.address, 101, sender=accounts[0])
    kernel.executeAction(4, lz_nft_bridge.address, sender=accounts[0])

    counter.inc(sender=accounts[0])

    count = counts.counts(accounts[0].address, sender=accounts[0])
    assert count == 1
