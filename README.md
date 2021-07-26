# FOLCRAWLER

A simple Ruby on Rails application that scrapes the news from two specific websites.
> PRs and issues welcome!

![](folcrawler.gif)

# Prerequisites

- Ruby 3.0+
- Rails 6.1.4+
- Node.js 12+ || 14+
- Yarn 1.x+ || 2.x+
- Redis
- Sidekiq
- RVM


# Getting started
First clone the repo and `cd` into the directory:

```
$ git clone https://github.com/marcelocd/folcrawler.git
$ cd folcrawler
```
Create a new gemset for the application:
```
$ rvm gemset create folcrawler
```
Switch to the required ruby version among with the new created gemset:
```
$ rvm 3@folcrawler
$ rvm current
```

Then, install the gems (while skipping any gems needed only in production):

```
$ bundle install --without production
```

Install JavaScript dependencies:

```
$ yarn install
```

Next, create and migrate the database:

```
$ rails db:create
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rspec spec
```

If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails s
```
## Crawlers
### Running them mannually
To run the crawlers manually, you will need to open three terminal tabs from the project repository: one to run redis, another one to run sidekiq, and one to run the tasks.
(*Don't forget to run `rvm 3@folcrawler` on each terminal before anything!*)

On terminal A:
```
$ redis-server
```

Terminal B:
```
$ sidekiq
```
On the third terminal, you may choose from three options:
1) Run a crawler just for the Culture website:
```
rake crawlers:scrape_culture_articles
```
2) Run a crawler just for the Social Development website:
```
rake crawlers:scrape_social_development_articles
```
3) Run both crawlers:
```
rake crawlers:scrape_articles
```
## License

This source code is available under the MIT License and the Beerware License. See [LICENSE.md](LICENSE.md) for details.
