# dracontion
a vyper cross-chain state sharing application platform

> dev: what is an ancient greek word that roughly translates to "bridge made of serpents"?

> ChatGPT: The ancient Greek word you are referring to is "dracontion" (δρακόντιον), which means "serpent bridge". This term was used to describe a type of bridge that was built using the bodies of snakes or serpents, either real or mythical. The concept of a serpent bridge was likely inspired by the legend of the Lernaean Hydra, a many-headed serpent that was slain by the hero Heracles (Hercules in Roman mythology) as one of his twelve labors.

## architecture

dracontion roughly follows the approach defined by the [Default Framework](https://github.com/fullyallocated/Default), with a few modifications

### plugins (final name TBD)

In addition to modules (encapsulating state) and policies (encapsulating user-facing logic) we introduce the idea of plugins, providing useful functionality to policies while not necessarily being user-facing contracts themselves.

#### examples

* Bridge Plugins, exposing a convenient API to enabled policies.
