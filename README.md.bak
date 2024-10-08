# ite2024

## Что потребуется для участия в мастер-классе

1. Ноутбук с os windows/linux (желательно debian based)
2. Установленная платформа 1С (версия > 8.3.21, желательно самая последняя). Вполне подойдет community вариант лицензции. 
3. Установленный http клиент: postman или insomnia

## Подключение к брокеру

Адрес брокера: 

```bash
rc1a-2s9sm9ccoj0v6v5c.mdb.yandexcloud.net:9091
```

## Подключение через утилиту plumber

```bash
./plumber_win.exe read kafka --topics=testTopic --address="rc1a-2s9sm9ccoj0v6v5c.mdb.yandexcloud.net:9091" --continuous --use-tls --tls-skip-verify --sasl-username=ite2024  --sasl-password=ite2024TheBest
```

## Устанавливаем сертификат

Linux:

```bash
mkdir -p /usr/local/share/ca-certificates/Yandex && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
     --output-document /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt && \
chmod 0655 /usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt
```

Windows:

```ps
mkdir $HOME\.kafka; curl.exe -o $HOME\.kafka\YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem
```


