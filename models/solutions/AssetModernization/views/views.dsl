# Views for the Asset Modernization solution — kept next to the architecture
# they visualise (see ../architecture/). Included by the workspace views block.

systemContext assetModernization "AssetModernization-Context" "AssetModernization and its direct dependencies." {
    include *
    autoLayout tb
}

container assetModernization "AssetModernization-Containers" "C4 level 2: containers of the Asset Modernization solution." {
    include *
    autoLayout lr
}
