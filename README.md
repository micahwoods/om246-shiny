### OM246 testing and the calculations

This app (hosted at <https://asianturfgrass.shinyapps.io/om246/>) makes calculations for total organic material measured by what I call **OM246**. You can see full details at the [OM246 project page](https://www.asianturfgrass.com/project/om246/) on the ATC website. This is a simple test, with two key features:

* the depth of the sample is known
* all the organic material is burned, with no screening or subsampling of the sample at the lab to remove undecomposed plant material

The point of this test is to make sure one is doing enough work to effectively manage organic matter at the surface of sand-based rootzones. By measuring the total organic material at a known depth over time, one can adjust the disruptive cultivation and sand topdressing work to be just enough, but no more. See how to do that, along with examples and more details about these tests, at these links:

* [This one simple trick](https://www.asianturfgrass.com/post/one-simple-trick-better-greens/) can transform putting greens from usually good to consistently great

* Soil organic matter: [a bullet list](https://www.asianturfgrass.com/post/soil-organic-matter-bullet-list/)

* [A Tale of Two Tests](https://www.asianturfgrass.com/post/tale-two-tests-soil-organic-matter/)

The calculations to find the accumulation rate and topdressing requirement are not as straightforward as one might expect. When the OM changes, so does the bulk density of the soil. When sand topdressing is added, the bulk density, organic matter, and depth of the layer under consideration all change too. 

In these calculations, I have used a fixed bulk density of 1.56 g cm<sup>-3</sup> for sand and 0.22 g cm<sup>-3</sup> for organic matter. 

The app calculates a site specific OM accumulation rate and sand topdressing requirement with user-specified input data.

Please file bug reports and feature requests at the [om246-shiny](https://github.com/micahwoods/om246-shiny/issues) GitHub repository.

[This short video](https://youtu.be/Tc8dcBBt1zc) explains each part of OM246 testing, from sampling to sand topdressing recommendations.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Tc8dcBBt1zc?si=n39wttWMao7ovmpu" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>