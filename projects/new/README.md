# new elm-spa project


## local development

__First time setup__ (includes initial install and build):

```
npm start
```

__Anytime after that__ (won't exit on failed build):

```
npm run dev
```


## deploying

After you run `npm run build`, the contents of the `public` folder
can be hosted as a static site. If you haven't hosted a static
site before, I'd recommend using [Netlify](https://netlify.com) (it's free!)

### with netlify

1. Create a file named `netlify.toml`

```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

__Build command:__ `npm run build`

__Publish directory:__ `public`