# Tableau Connector Testing Quick Start Guide

## 1. Install Tableau Desktop and the TDVT test framework
- Install [Tableau Desktop](https://www.tableau.com/products/desktop)
    - Currently using 2022.3
    - Tableau must be licensed. The trial will not work for testing
- Clone the [connector-plugin-sdk](https://github.com/tableau/connector-plugin-sdk)
    - Currently using [tdvt-2.6.11 tag](https://github.com/tableau/connector-plugin-sdk/releases/tag/tdvt-2.6.11) 
    - Follow _Setup_ section [here](https://tableau.github.io/connector-plugin-sdk/docs/tdvt), skipping steps 3 & 5

## 2. Start Pinot and populate with the test data
- Set machine timezone to UTC. Without this almost all time based tests will fail
- Set the PINOT_PATH environment variable to your pinot build directory, something like ~/projects/startree/pinot/build
- Start the Pinot Servers
	- start and stop_pinot.sh scripts are included
	- To use them, you'll need to set 2 environment variables:
		- PINOT_PATH, should be already set from above
		- SERVER_LOGS_PATH to a directory for the logs, could be ./logs
- Open a terminal and cd into the `test/schema` directory
- Execute `./putdata.sh`

## 3. Build the .taco file
- In this directory, execute `mvn package`
- The .taco file with be created in the `target` directory

## 4. Configure Tableau to work with Pinot
- Copy the Pinot JDBC Driver Shaded jar to `$HOME/Library/Tableau/Drivers`
- Copy the `.taco` file in the `target` directory (currently `ai.startree.pinot-0.13.0-SNAPSHOT.taco`) to `$HOME/Documents/My\ Tableau\ Repository/Connectors`
- cd into the `test` directory
- Execute `python3 make_tds.py cast_calcs.pinotdb.tds.template {hostname} > tds/cast_calcs.pinotdb.tds` where `{hostname}` is the host running Pinot (like `localhost`)
- Execute `python3 make_tds.py Staples.pinotdb.tds.template {hostname} > tds/Staples.pinotdb.tds`

## 5. Run the tests
- cd into the `test` directory
- Execute `python3 -m tdvt.tdvt run pinotdb --generate`
- Results are saved in `test_results_combined.csv`


## Running tests for V2 query engine
- Replace the `dialect.tdd` file with `dialectV2.tdd` file
- Add `&useMultistageEngine=true` to the JDBC URL in the `connectionBuilder.js` file
- Rest all steps are same as above. No need to restart the Pinot servers or put data again.

## Notes
- For most of the time based tests to pass, the Pinot host must be in the UTC timezone
- If the start/stop_pinot.sh scripts are not used to run Pinot, be sure Pinot is configured with
    - `pinot.server.instance.currentDataTableVersion=4`

## Current TDVT Results

| Metric          | V1 Query Engine | V2 Query Engine |
|-----------------|-----------------|-----------------|
| Test Count      | 863             | 863             |
| Passed tests    | 781             | 754             |
| Failed tests    | 82              | 109             |
| Tests run       | 863             | 863             |
| Disabled tests  | 0               | 0               |
| Skipped tests   | 0               | 0               |

