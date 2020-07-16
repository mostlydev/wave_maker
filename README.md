# WaveMaker

## Summary

This is a tool that converts PayPal CSV exports to Wave Accounting-compatible import files.

## Simplest Use

Save your PayPal CSV into a folder, let’s say you called it: `PayPal.CSV`

Download `make_wave.rb` from Terminal.

$ curl https://raw.githubusercontent.com/mostlydev/wave_maker/master/lib/mostlydev/wave_maker.rb > make_wave.rb

Then, run the script on your CSV file:

```
$ ruby make_wave.rb PayPal.CSV
```

You’ll see some output like this:

```
PayPal to Wave-importable CSV converter
Copyright (c) 2019 Wojtek Grabski (mostlydev.com)
------
... created PayPal.usd.wave.csv
... created PayPal.cad.wave.csv
... outputted 2202 rows
```

That’s it.

You should import each of the resulting csv files into its own currency-specific PayPal account in Wave.
