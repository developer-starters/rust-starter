FROM rust:1.80 as builder
WORKDIR /opt/app

RUN apt-get update -qq && apt-get install -yqq musl-tools
COPY src/ src/
COPY Cargo.toml .
COPY Cargo.lock .
RUN rustup target add x86_64-unknown-linux-musl 
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM alpine:3.19.0

COPY --from=builder /opt/app/target/x86_64-unknown-linux-musl/release/rust-starter /usr/local/bin

ENTRYPOINT ["/usr/local/bin/rust-starter"]
