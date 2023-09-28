# sure-upload

Static file hosting and serving web app and service. Simple, bucket-oriented.

```bash
docker build -t sure-upload .
```

```bash
docker run -d -p 3000:3000 -e DATABASE_URL=postgres://postgres:1234@localhost:5432/sure_upload -e JWT_SECRET=sure_upload -e PORT=3000 sure-upload
```
