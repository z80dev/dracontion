# dracontion
a vyper cross-chain state sharing application platform

dracontion instances can contain various components as well as communicate with other dracontion instances. these instances may be spread across chains. These components may be written in Vyper, Solidity, Huff, Dasy, or any other EVM language.

dracontion components can act independently or coordinate between themselves, enforcing various levels of permissions on interactions between components.

> dev: what is an ancient greek word that roughly translates to "bridge made of serpents"?

> ChatGPT: The ancient Greek word you are referring to is "dracontion" (δρακόντιον), which means "serpent bridge". This term was used to describe a type of bridge that was built using the bodies of snakes or serpents, either real or mythical. The concept of a serpent bridge was likely inspired by the legend of the Lernaean Hydra, a many-headed serpent that was slain by the hero Heracles (Hercules in Roman mythology) as one of his twelve labors.

## architecture

dracontion roughly follows the approach defined by the [Default Framework](https://github.com/fullyallocated/Default), with a few modifications

### modules 

Modules contain application state. This state may be referenced and written to by more than one policy. The Kernel may restrict or grant access to Modules.


### policies

policy contracts will expose an interface for effecting state changes. these are contracts meant for direct user interaction. Policies depend on the Kernel for access to Modules.

### plugins (final name TBD)

In addition to modules (encapsulating state) and policies (encapsulating user-facing logic) we introduce the idea of plugins, providing useful functionality to policies while not necessarily being user-facing contracts themselves.

plugins can also enable interconnected procedures across dracontion instances

#### examples

* Bridge Plugins, exposing a convenient API to enabled policies.
* Permit2 Adaptor
* Seaport Adaptor
