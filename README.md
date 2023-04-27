# Course on Software Product Lines

**[Open educational resources](https://en.wikipedia.org/wiki/Open_educational_resources) for lectures on software product lines**

*If you have any feedback, please contact [Thomas Thüm](mailto:thomas.thuem@uni-ulm.de).*

<a href="https://github.com/SoftVarE-Group/Slides-of-the-SPL-Course">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="pics/course/overview-dark.png">
  <img src="pics/course/overview-light.png">
</picture>
</a>

## Contributors

- Thomas Thüm (University of Ulm, Germany)
- Timo Kehrer (University of Bern, Switzerland)
- Elias Kuiter (University of Magdeburg, Germany)

## Usage in Lectures

- University of Bern, Switzerland: Software Product Lines (Winter Term 2022/23)
- University of Magdeburg, Germany: Implementation Techniques for Software Product Lines (Winter Term 2022/23)
- Harz University of Applies Sciences, Wernigerode, Germany: Requirements Engineering II - Software Product Lines (Summer Term 2023)
- University of Ulm, Germany: Software Product Lines (Summer Term 2023)

## PDF Slides

To reduce the size of this repository, generated slides are available in a dedicated repository: https://github.com/SoftVarE-Group/Slides-of-the-SPL-Course

<!--
## Exercises

Exercise sheets for this course are available in a dedicated repository: https://github.com/SoftVarE-Group/Course-on-Software-Product-Lines-Exercises
-->

## Getting Started

```
git clone --recursive https://github.com/SoftVarE-Group/Course-on-Software-Product-Lines.git
cd Course-on-Software-Product-Lines/slides
make # to compile all slides with default options
make <lecture>.pdf handout=... darkmode=... university=... # to compile one lecture with given options (for valid values, see Makefile)
docker run --rm -v $(pwd)/..:/spl -w /spl/slides texlive/texlive:TL2021-historic make # to compile all slides with Texlive 2021 in Docker
```

## License

All course material is licensed under the <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC-BY-SA-4.0</a> license (Creative Commons Attribution Share Alike).

<p align="center">
	<a href="http://creativecommons.org/licenses/by-sa/4.0/"><img src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" alt="CC-BY-SA-4.0"/></a>
</p>

<p align="center">
	<a href="https://creativecommons.org/share-your-work/public-domain/freeworks"><img src="https://upload.wikimedia.org/wikipedia/commons/b/b7/Approved-for-free-cultural-works.svg" alt="Approved for Free Cultural Works"/></a>
</p>
