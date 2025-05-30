###############################################
## Build Stage                               ##
###############################################
FROM rust:alpine AS builder

# Install build dependencies
RUN apk --no-cache add git make gcc musl-dev perl && cargo install mdbook && cargo install mdbook-typst-pdf

# Change to work directory
WORKDIR /source

# Fetch source code and build targets
RUN git clone https://github.com/KaiserY/trpl-zh-cn.git && cd trpl-zh-cn && mdbook build


###############################################
## Appy Stage                                ##
###############################################
FROM nginx:stable-alpine AS trpl-zh-cn

RUN rm /etc/nginx/conf.d/default.conf

# Copy targets resources from build stage, as it's name 'builder'
COPY --from=builder /source/trpl-zh-cn/book/html /usr/share/nginx/html

# Copy resource file from host
COPY nginx.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

