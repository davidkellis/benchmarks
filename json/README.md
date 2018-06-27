# json Benchmark

This benchmark calculates the arithmetic average of a set of 3-dimensional coordinates stored in a json document read from disk.

### Implementation

The json document that this benchmark will read from disk has the following structure:
```
{
  "info": "some info",
  "coordinates": [
    {
      "x"=>0.5567886739879128,
      "y"=>0.7125656768666822,
      "z"=>0.9268088415390159,
      "name"=>"mcydwn 6686",
      "opts"=>{"1"=>[1, true]}
    },
    {
      "x"=>0.7144426787467205,
      "y"=>0.5940087521750321,
      "z"=>0.8100953588732464,
      "name"=>"pnqvxs 3507",
      "opts"=>{"1"=>[1, true]}
    },
    {
      "x"=>0.5538818756281689,
      "y"=>0.7260777387882161,
      "z"=>0.6039080447615149,
      "name"=>"esviyn 9916",
      "opts"=>{"1"=>[1, true]}
    },
    ...
  ]
}
```
such that the array of coordinates contains 1,000,000 coordinate objects.

The json file is named `sample.json`.

An implementation of this benchmark should do the following:
1. Read the entire json document from disk into memory.
2. Calculate the arithmetic mean of the x coordinates, the y coordinates, and the z coordinates. The calculations should be independent of one another - we want to calculate the x-mean, the y-mean, and the z-mean.

   Note: The x, y, and z coordinates are double-precision floating point values.
3. Print three lines of output to standard out (STDOUT), in the format:
   ```
   <mean-x>
   <mean-y>
   <mean-z>
   ```
   The line should be terminated with a newline.