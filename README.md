# Elixir Shipping Calculator

For the exercise you'll have to build a pricing model and then use it to calculate
and display the prices of a number of shipments.

* Shipments are priced based on delivery range and weight.
* Range is determined by the zones of the origin and destination suburbs.
* If the suburbs are in the same zone, the range is `same-zone`.
* If the origin is in two different zones, the range is `different-zone`.
* If either the origin or destination is not in a zone, the shipment is not serviced.
* If the weight exceeds the maxium weight, the shipment is not serviced.

The pricing model should be built from the following two data files. These files can be found in the `priv` directory.

* `zones.csv` This contains the zone information. Zones are lists of suburbs, postcode pairs and a zone name.
* `prices.csv` Each row contains the price to deliver a parcel of a given weight for a given range. All prices are in the same currency and weights are in grams.
