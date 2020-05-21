# new elm-spa project


## local development

```
npm start
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
