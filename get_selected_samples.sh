#!/usr/bin/env sh

for dir in hopfield_nets poly_approx reach_prob_density reinforcement_learning; do
    mkdir -p "samples/$dir"
    mkdir -p "esbmc_output/$dir"
done

rsync -av --progress --files-from="./selected_sample_names" $DATA_SERVER_LOGIN:ext/plain_nn/patched-src-2/ "samples/"
rsync -av --progress --files-from="./selected_esbmc_output_names" $DATA_SERVER_LOGIN:ext/plain_nn/esbmc_output/ "esbmc_output/"
