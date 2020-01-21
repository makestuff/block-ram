## Various block-ram modules
You can git submodule this repo to provide some common block-ram configurations. See [`altera-pcie`](https://github.com/makestuff/altera-pcie) repo for an example of how to do this.

[`makestuff_ram_sc_be`](ram_sc_be.sv): Single-clock block-RAM with eight byte-enables.

To run the tests:

    make test
