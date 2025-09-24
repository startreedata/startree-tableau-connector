# Tableau Connector For Startree Pinot

This is the Tableau Connector for [Startree Pinot](https://startree.ai).

We are working on making this connector available in the Tableau Exchange. For now, the connector can be installed and used as follows.

## Installation & Usage
* Pinot setup requires JDK 11 and Maven 3.6

* Download the driver jars. When using Pinot 1.0.0, the driver versions below will be needed
    - async-http-client-2.12.3.jar
    - calcite-core-1.30.0.jar
    - [pinot-jdbc-client-1.0.0-hotfix-shaded.jar](https://mvnrepository.com/artifact/org.apache.pinot/pinot-jdbc-client)

* Copy the driver to the Tableau drivers directory
    - On Mac: `~/Library/Tableau/Drivers/`
    - On Windows: `C:\Program Files\Tableau\Drivers`

* Fork this repository

* Exec `mvn package` in this directory to build the connector. The `.taco` file will be in the `target` subdirectory. 

* Copy the `.taco` to the connectors directory
    - On Mac: `~/Library/Tableau/Connectors/` 
    - On Windows: `C:\Users\[user]\Documents\My Tableau Repository\Connectors`

* Launch Tableau Desktop with connector signature verification disabled.  
    - On Mac: `/Applications/Tableau\ Desktop\ <version>.app/Contents/MacOS/Tableau -DDisableVerifyConnectorPluginSignature=true` 
    - On Windows: `tableau.exe -DConnectPluginsPath=C:\tableau_connector`

* Select the connector from installed connectors

![Tableau Connectors](plugins/pinotjdbc/static/img/tableau_connector_ui.png?raw=true "Installed Connectors")

<br/>

![Apache Pinot Connection Dialog](plugins/pinotjdbc/static/img/tableau_connector_dialog.png?raw=true "Apache Pinot Connection Dialog")


![Fetch data from Pinot](plugins/pinotjdbc/static/img/tableau_tables_ui.png?raw=true "Fetch data from Pinot")

## Testing
- Prerequisites:
  - **Tableau Desktop (licensed)** and **tabquerytool** installed
  - **Connector SDK/TDVT** cloned and set up (`tdvt-2.6.11`)
  - **Driver JARs** in `~/Library/Tableau/Drivers/`:
    - `async-http-client-2.12.3.jar`
    - `calcite-core-1.30.0.jar`
    - `pinot-jdbc-client-1.0.0-hotfix-shaded.jar`
  - Set mac path to `tabquerytool` in `test/config/tdvt/tdvt.ini`
  - System timezone set to UTC

- Start Pinot and load test data:
```bash
export PINOT_PATH=/path/to/pinot/build
export SERVER_LOGS_PATH=$PWD/logs
./start_pinot.sh
(cd schema && ./putdata.sh)
```

- Build and install the connector for TDVT:
```bash
mvn package
mkdir -p ~/Documents/My\ Tableau\ Repository/Connectors
cp target/ai.startree.pinot-startree-tableau-connector-1.0.taco ~/Documents/My\ Tableau\ Repository/Connectors/
```

- Generate TDS files pointing to your Pinot host:
```bash
python3 make_tds.py cast_calcs.pinotdb.tds.template localhost > tds/cast_calcs.pinotdb.tds
python3 make_tds.py Staples.pinotdb.tds.template    localhost > tds/Staples.pinotdb.tds
```

- Run TDVT:
```bash
python3 -m tdvt.tdvt run pinotdb --generate --config config/tdvt/tdvt.ini
```

- Results:
  - **CSV**: `test_results_combined.csv` (in the working directory)

- Optional (V2 query engine):
  - Replace `plugins/pinotjdbc/dialect.tdd` with `plugins/pinotjdbc/dialectV2.tdd`
  - Add `&useMultistageEngine=true` to the JDBC URL in `plugins/pinotjdbc/connectionBuilder.js`
  - Re-run the same TDVT command

- Note:
  - Desktop signature verification flag is not needed for TDVT runs (it uses `tabquerytool`).


## Signing the TACO file

Maven is configured to sign the `.taco` file during the package stage.

Signing requires the following maven properties
* taco.signing.keystore - The path to the `.jks` file containing the code-signing certificate (defaults to `taco.jks`)
    * NOTE: the `taco.jks` in this directory is just a placeholder. It DOES NOT contain a valid certificate and must be replaced with a valid `.jks` file when actually signing the `.taco` for distribution
* taco.signing.alias - The alias for the keystore entry that contains the private key needed to generate the signature (defaults to `alias`)
* taco.signing.storepass - The password for the keystore (defaults to `storepass`)
* taco.signing.keypass - The password for the keystore entry (defaults to empty)

For example, to build a signed `.taco` file
* `mvn package -Dtaco.signing.keystore=taco.jks -Dtaco.signing.alias=pinotkeyalias -Dtaco.signing.storepass=tacostorepass -Dtaco.signing.keypass=tacokeypass`

To automate the building/signing of the `.taco` secrets could be used along with a github action to run the build with the properties configured from values stored in the secrets.

### References

[Package and Sign Your Connector for Distribution](https://help.tableau.com/current/api/webdataconnector/en-us/docs/wdc_packaging.html)