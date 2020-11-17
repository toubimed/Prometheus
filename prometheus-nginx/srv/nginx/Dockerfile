FROM ubuntu:18.10

ENV NGINX_VERSION 1.15.6
ENV VTS_VERSION 0.1.18

#Install dependencies
RUN apt update && apt install curl gcc libpcre++-dev libgeoip-dev zlib1g-dev build-essential libxslt-dev libssl-dev libgd-dev -y

#Download NGINX and NGINX-VTS
RUN curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    	&& curl -fSL https://github.com/vozlt/nginx-module-vts/archive/v$VTS_VERSION.tar.gz  -o nginx-modules-vts.tar.gz

RUN tar -zxC /usr/local/src -f nginx.tar.gz \
    	&& tar -zxC /usr/local/src -f nginx-modules-vts.tar.gz


RUN rm nginx.tar.gz nginx-modules-vts.tar.gz
RUN ls /usr/local/src/nginx-$NGINX_VERSION

RUN CONFIG="\
    		--prefix=/etc/nginx \
    		--sbin-path=/usr/sbin/nginx \
    		--modules-path=/usr/lib/nginx/modules \
    		--conf-path=/etc/nginx/nginx.conf \
    		--error-log-path=/var/log/nginx/error.log \
    		--http-log-path=/var/log/nginx/access.log \
    		--pid-path=/var/run/nginx.pid \
    		--lock-path=/var/run/nginx.lock \
    		--http-client-body-temp-path=/var/cache/nginx/client_temp \
    		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    		--user=nginx \
    		--group=nginx \
    		--with-http_ssl_module \
    		--with-http_realip_module \
    		--with-http_addition_module \
    		--with-http_sub_module \
    		--with-http_dav_module \
    		--with-http_flv_module \
    		--with-http_mp4_module \
    		--with-http_gunzip_module \
    		--with-http_gzip_static_module \
    		--with-http_random_index_module \
    		--with-http_secure_link_module \
    		--with-http_stub_status_module \
    		--with-http_auth_request_module \
    		--with-http_xslt_module=dynamic \
    		--with-http_image_filter_module=dynamic \
    		--with-http_geoip_module=dynamic \
    		--with-threads \
    		--with-stream \
    		--with-stream_ssl_module \
    		--with-stream_ssl_preread_module \
    		--with-stream_realip_module \
    		--with-stream_geoip_module=dynamic \
    		--with-http_slice_module \
    		--with-mail \
    		--with-mail_ssl_module \
    		--with-compat \
    		--with-file-aio \
    		--with-http_v2_module \
            --add-module=/usr/local/src/nginx-module-vts-$VTS_VERSION \
    	    " \

&& cd /usr/local/src/nginx-$NGINX_VERSION \

    && ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& ls objs/src/http/modules/ \
	&& ls objs/nginx \
	&& mv objs/nginx objs/nginx-debug \
    && mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
	&& ./configure $CONFIG \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
	&& ln -s ../../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& rm -rf /usr/local/src/nginx-$NGINX_VERSION


RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
RUN addgroup --system nginx \
&& useradd nginx -g nginx -m -d /var/cache/nginx
STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
