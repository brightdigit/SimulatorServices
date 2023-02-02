#!/bin/sh
xcodebuild docbuild -scheme SimulatorServices -derivedDataPath DerivedData
$(xcrun --find docc) process-archive transform-for-static-hosting DerivedData/Build/Products/Debug/SimulatorServices.doccarchive --output-path Output