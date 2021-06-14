### OM246 testing and the calculations

This app[^1] makes calculations for total organic material measured by what I call OM246. You can see more details at the [OM246 project page](https://www.asianturfgrass.com/project/om246/) on the ATC website. This is a simple test, with two key features:

[^1]: <https://asianturfgrass.shinyapps.io/om246/>

* the depth of the sample is known
* all the organic material is burned, with no screening or subsampling of the sample at the lab to remove undecomposed plant material

The point of this is to make sure one is doing enough work to effectively manage organic matter at the surface of sand-based rootzones. By measuring the total organic matter at a known depth over time, one can adjust the disruptive cultivation and sand topdressing work to be just enough, but no more. See how to do that, along with examples and more details about these tests, at these links:

* [This one simple trick](https://www.asianturfgrass.com/post/one-simple-trick-better-greens/) can transform putting greens from usually good to consistently great

* Soil organic matter: [a bullet list](https://www.asianturfgrass.com/post/soil-organic-matter-bullet-list/)

* [A Tale of Two Tests](https://www.asianturfgrass.com/post/tale-two-tests-soil-organic-matter/)

The calculations to find the accumulation rate and topdressing requirement are not as straightforward as one might expect. When the OM changes, so does the bulk density of the soil. When sand topdressing is added, the bulk density, organic matter, and depth of the layer under consideration all change too. 

In these calculations, I have used a fixed bulk density of 1.56 g cm<sup>-3</sup> for sand and 0.22 g cm<sup>-3</sup> for organic matter. 

In the future I may add more functionality, such as options to switch between metric and U.S. customary units, and the effect of organic matter removal by hollow core cultivation. There are other calculations and charts that I make for OM246 reports that I might add to this too. At the moment, the app calculates a site specific OM accumulation rate for a single depth, and calculates a topdressing required for a single depth.

Please file bug reports and feature requests at the [om246-shiny](https://github.com/micahwoods/om246-shiny) GitHub repository.