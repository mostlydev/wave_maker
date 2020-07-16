# Wave Maker

## License

Copyright (c) 2019 Wojtek Grabski (mostlydev.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


## Summary

This is a tool that converts PayPal CSV exports to Wave Accounting-compatible import files.

## Simplest Use (Web-based)

I've created a web page where you can use this script without having to run it on your computer:

https://www.mostlydev.com/make-waves/

## Download and Run Manually

Save your PayPal CSV into a folder, let’s say you called it: `PayPal.CSV`

Download `make_wave.rb` from Terminal.

$ curl https://raw.githubusercontent.com/mostlydev/wave_maker/master/lib/mostlydev/wave_maker.rb > wave_maker.rb

Then, run the script on your CSV file:

```
$ ruby wave_maker.rb PayPal.CSV
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

## TODO

The actual little app that runs it.
