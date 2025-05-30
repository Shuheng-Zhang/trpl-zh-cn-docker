FROM rust:alpine AS builder

RUN apk --no-cache add git make gcc musl-dev perl && cargo install mdbook && cargo install mdbook-typst-pdf

WORKDIR /source

RUN git clone https://github.com/KaiserY/trpl-zh-cn.git && cd trpl-zh-cn && mdbook build

FROM nginx:stable-alpine AS trpl-zh-cn

RUN rm /etc/nginx/conf.d/default.conf
COPY --from=builder /source/trpl-zh-cn/book/html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

