# Tableau Connector Testing Quick Start Guide

## 1. Install Tableau Desktop and the TDVT test framework
- Install [Tableau Desktop](https://www.tableau.com/products/desktop)
    - Currently using 2022.3
    - Tableau must be licensed. The trial will not work for testing
- Clone the [connector-plugin-sdk](https://github.com/tableau/connector-plugin-sdk)
    - Check out the [tdvt-2.6.11 tag](https://github.com/tableau/connector-plugin-sdk/releases/tag/tdvt-2.6.11).
    - Follow the [TDVT setup instructions](https://tableau.github.io/connector-plugin-sdk/docs/tdvt) to install its Python module from `connector-plugin-sdk/tdvt` in a virtual environment. Use this repository's existing `test` directory as the TDVT workspace instead of creating another workspace.

## 2. Start Pinot and populate with the test data
- Set the test machine timezone to UTC. Without this almost all time based tests will fail. On macOS, the command is `sudo systemsetup -settimezone GMT`.
- Set the PINOT_PATH environment variable to your pinot build directory, something like ~/projects/startree/pinot/build
- From the connector repository root, run `cd test`, then `./start_pinot.sh`. The `start_pinot.sh` and `stop_pinot.sh` scripts must run from this directory.
	- To use them, you'll need to set 2 environment variables:
		- PINOT_PATH, should be already set from above
		- SERVER_LOGS_PATH to a directory for the logs, could be ./logs
- In another terminal, from the connector repository root, run `cd test/schema`, then `./putdata.sh`.

## 3. Build the .taco file
- From the connector repository root (where `pom.xml` is), use JDK 17 and execute `mvn clean package`.
- The `.taco` file will be created in `target`. Use `package` for testing; `install` also attempts artifact signing.

## 4. Configure Tableau to work with Pinot
- Copy the Pinot JDBC Driver Shaded jar to `$HOME/Library/Tableau/Drivers`
- Copy `target/ai.startree.pinot-startree-tableau-connector-1.0.taco` to `"$HOME/Documents/My Tableau Repository/Connectors"`.
- Set `TAB_CLI_EXE_MAC` in `test/config/tdvt/tdvt.ini` to your installed Tableau Desktop's `tabquerytool` path. The checked-in path uses Tableau 2024.1; adjust the version to match your installation.
- From the connector repository root, run `cd test`.
- Execute `python3 make_tds.py cast_calcs.pinotdb.tds.template {hostname} > tds/cast_calcs.pinotdb.tds` where `{hostname}` is the host running Pinot (like `localhost`)
- Execute `python3 make_tds.py Staples.pinotdb.tds.template {hostname} > tds/Staples.pinotdb.tds`

## 5. Run the tests
- From the connector repository root, run `cd test`, using the virtual environment where TDVT is installed.
- Execute `python3 -m tdvt.tdvt run pinotdb --generate`. TDVT reads `config` and `tds` relative to this working directory.
- Results are saved in `test/test_results_combined.csv` relative to the repository root.


## Running tests for V2 query engine
- From the connector repository root, copy `plugins/pinotjdbc/dialectV2.tdd` over `plugins/pinotjdbc/dialect.tdd`, then repeat steps 3 and 4 to rebuild and reinstall the `.taco`.
- After generating the TDS files in step 4, add `v-multistage='true'` to the inner `<connection class='pinot' ... />` element in **both** `test/tds/cast_calcs.pinotdb.tds` and `test/tds/Staples.pinotdb.tds`. The existing connection builder reads this attribute to set `useMultiStageEngine=true`.
- Repeat step 5. No need to restart the Pinot servers or load the data again. To return to V1, restore the original `dialect.tdd`, remove `v-multistage` (or set it to `false`) in both TDS files, and rebuild and reinstall the `.taco`.

## Notes
- For most of the time based tests to pass, the Pinot host must be in the UTC timezone
- If the start/stop_pinot.sh scripts are not used to run Pinot, be sure Pinot is configured with
    - `pinot.server.instance.currentDataTableVersion=4`

## Current TDVT Results

| Metric          | V1 Query Engine | V2 Query Engine |
|-----------------|-----------------|-----------------|
| Test Count      | 865             | 863             |
| Passed tests    | 810             | 754             |
| Failed tests    | 55              | 109             |
| Tests run       | 865             | 863             |
| Disabled tests  | 0               | 0               |
| Skipped tests   | 0               | 0               |

