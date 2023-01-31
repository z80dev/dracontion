# dracontion
a vyper cross-chain state sharing application platform

dracontion instances can contain various components as well as communicate with other dracontion instances. these instances may be spread across chains. These components may be written in Vyper, Solidity, Huff, Dasy, or any other EVM language.

> dev: what is an ancient greek word that roughly translates to "bridge made of serpents"?

> ChatGPT: The ancient Greek word you are referring to is "dracontion" (δρακόντιον), which means "serpent bridge". This term was used to describe a type of bridge that was built using the bodies of snakes or serpents, either real or mythical. The concept of a serpent bridge was likely inspired by the legend of the Lernaean Hydra, a many-headed serpent that was slain by the hero Heracles (Hercules in Roman mythology) as one of his twelve labors.

## architecture

dracontion roughly follows the approach defined by the [Default Framework](https://github.com/fullyallocated/Default), with a few modifications

### modules 

Modules contain application state. This state may be referenced and written to by more than one policy. Modules and/or the kernel may enforce permissions on policies and which functions they may call.


### policies

policy contracts will expose an interface for effecting state changes. these are contracts meant for direct user interaction.

### plugins (final name TBD)

plugins will enable interconnected procedures across dracontion instances

these instances can exist on different chains

In addition to modules (encapsulating state) and policies (encapsulating user-facing logic) we introduce the idea of plugins, providing useful functionality to policies while not necessarily being user-facing contracts themselves.

#### examples

* Bridge Plugins, exposing a convenient API to enabled policies.
