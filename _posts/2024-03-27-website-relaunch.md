---
title: "Website Relaunch"
author: straight-shoota
summary: "Fresh design and new content on crystal-lang.org"
image: /assets/blog/2024/2024-03-27-website-homepage-new.webp
categories: project
tags: [website]
---

The Crystal website here at [crystal-lang.org](https://crystal-lang.org) has received a major overhaul.

This project has been in the making for a long time, with the first design previews dating back at least to 2020. Many people have been involved in the process which made very slow progress because there were always more important things to do (such as developing a programming language).
But the limitations of the old website have been quite substantial and finally we managed to complete the relaunch.

Some of the highlight improvements:

* Responsive layout that fits small and large viewports
* Refined typography
* Enhanced site navigation system
* completely reorganised [homepage](/)
* completely reorganised [_Install_ page](/install/)
* completely reorganised [_Community_ page](/community/)
* new [_Releases_ page](/releases/)
* Taxonomy (categories and tags) for blog posts
* Dark mode support

For comparison, the new and old homepage:

| ![New homepage](/assets/blog/2024/2024-03-27-website-homepage-new.webp) | ![Old homepage](/assets/blog/2024/2024-03-27-website-homepage-old.webp) |

New and old install page, release notes and community page:

| [![New release notes](/assets/blog/2024/2024-03-27-website-install-new.webp)](/install) | ![Old release notes](/assets/blog/2024/2024-03-27-website-install-old.webp) |
| [![New release notes](/assets/blog/2024/2024-03-27-website-release-new.webp)](/2024/01/18/1.11.2-released/) | ![Old release notes](/assets/blog/2024/2024-03-27-website-release-old.webp) |
| [![New release notes](/assets/blog/2024/2024-03-27-website-community-new.webp)](/community) | ![Old release notes](/assets/blog/2024/2024-03-27-website-community-old.webp) |

The underlying engine has remained the same: We're still using [Jekyll](https://jekyllrb.com) as static site generator. It has served us well and we expect it will continue to do so in the future.
The entire styles and many templates have been rebuilt from scratch to implement the new design. There has been good progress and broad browser adoption of modern web technologies that allows using some fancy new features like CSS layers and advanced grid layouts. We're still quite confident about good browser support with way over 90% coverage.

The new website has gone through a lot of reviews and quality control, but there are inevitably gonna be some mishaps. If you find any issues, please report them to [the bug tracker](https://github.com/crystal-lang/crystal-website/issues).
