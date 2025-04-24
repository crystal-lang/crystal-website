---
title: Using Crystal to power the IOU economy
author: mpettinati
description: Sikoba helps communities reduce their dependence on cash, by unlocking hidden financial resources.
company: Sikoba
image: /assets/blog/2019-05-01-sikoba.webp
categories: success
---

Sikoba is an IOU (“I owe you”) platform that automates the creation, tracking and finally clearing of debt between its users. While Sikoba can be used in a wide array of settings, like business to business contracts and clearings, it creates marketplaces for peer-to-peer credit-based transactions that is a great fit for small communities with struggling economies.

In situations where there is a shortage of money, Sikoba can help re-activate local economies. Alex Kampa, founder of Sikoba, puts it in very compelling terms: “**there is a lot you can do without money, as long as you have credit**”.

## How it all began

The Sikoba project originated in a [greenpaper authored by Aleksander Kampa](https://www.sikoba.com/docs/Sikoba_GreenPaper.pdf), its Founder & Director, where he described a blockchain-based platform that overcomes the limitations of informal credit.

Due to the combination of its high performance and clarity of code, Sikoba’s founder felt the [Crystal](https://manas.tech/projects/crystal/) programming language was a perfect fit for developing the underlying infrastructure for the Sikoba platform. With that in mind, he reached out to Manas to partner up in the creation of the [Sikoba network](https://medium.com/@sikoba.network) and app.

> _We became aware of Manas.Tech, the company where Crystal was born, and ended up talking to its founder, Nicolás di Tada. We were surprised to learn that Nico had a deep interest in monetary theory and alternative financial systems. He immediately understood and enthusiastically embraced the Sikoba project. This eventually resulted in the technology partnership between sikoba and Manas.Tech that is bringing the sikoba vision to life._

## Getting to work on the Sikoba app

Alex Kampa flew in from Luxembourg to visit Manas’ offices in Buenos Aires, and got to work with the Manas team on the product roadmap, designs of the first prototypes and planning for the release of the MVP.

The team estimated the scope of work, and held a round of spikes to reduce uncertainty. This was a medium-sized project, with a backend that had significant algorithmic and business logic complexity, 15 front-end features and 27 screens with several states each. On December 18th, 2018, after running our estimation process, we determined that we would have a first version ready by March 15th, 2019. The first functional version of the product was delivered on March 14th 2019, one day sooner than our team had estimated.

The Sikoba back-end has three components:

- Server to handle user requests

- Transaction Processor to manage and execute submitted transactions

- Services component to execute periodic actions and perform clearing

All of these components are written in the Crystal programming language using the [Lucky](https://www.luckyframework.org/) web framework, and it uses PostgreSQL to store data and Redis to store queued transactions. The entire system is built with and runs in Docker.

The Sikoba front-end consists of the **sikobaPay mobile app**, available for both ~~[Android](https://play.google.com/store/apps/details?id=com.sikoba.dev&hl=es_GT)~~ and iOS (currently in beta) and a web interface (currently under development).

The mobile app is written in React Native, while the web interface is written in React JS. Both communicate with the backend via a RESTful API.

## The road ahead

The Sikoba team has of late been focused on developing the blockchain infrastructure for their ecosystem, and on the launch of the Sikoba mainnet. In parallel, they have been busy with the development of the ~~[BekiPay app](https://play.google.com/store/apps/details?id=com.sikoba.bekiPay&hl=en&gl=US)~~, which will allow people and businesses of Luxembourg’s canton of Redange to use e-Bekis instead of paper Bekis, and cooperating with “Proyecto Banco Mujer” in Peru, a group of business women in Peru who are operating a small credit and savings ring that has started using the SikobaPay app to register loans.

{% include components/testimonial-profile.html handle="alex-kampa" role="Founder & Director, Sikoba" %}
