## Various block-ram modules
You can git submodule this repo to provide some common block-ram configurations.

[`makestuff_ram_sc`](ram_sc.sv): Single-clock block-RAM with single write-strobe.
[`makestuff_ram_sc_be`](ram_sc_be.sv): Single-clock block-RAM with write-mask.

See [BuildInfra](https://github.com/makestuff/ws-tools/blob/master/README.md) for details of how to incorporate this into your project.

You can install it in a new workspace `$HOME/my-workspace` like this:

    cd $HOME
    export ALTERA=/usr/local/altera-16.1  # or wherever
    mkws.sh my-workspace makestuff:block-ram
    export PROJ_HOME=$HOME/my-workspace

Then assuming you have ModelSim in your `PATH`, you can run all the tests:

    cd $PROJ_HOME/ip/makestuff/block-ram
    make test
