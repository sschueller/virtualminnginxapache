#!/bin/sh
# /usr/local/bin/virtualmin-postaction.sh
NGINX_CONF_FILE="/etc/nginx/sites-available/${VIRTUALSERVER_DOM}.conf "
NGINX_SSL_CONF_FILE="/etc/nginx/sites-available/${VIRTUALSERVER_DOM}_ssl.conf "

if [ "$VIRTUALSERVER_ACTION" = "CREATE_DOMAIN" ]; then
        if [ "${VIRTUALSERVER_WEB}" = "1" ];
        then
                cp /etc/nginx/sites-available/template.conf $NGINX_CONF_FILE

                perl -pi -e "s#{DOM}#$VIRTUALSERVER_DOM#g" $NGINX_CONF_FILE
                perl -pi -e "s#{SITE_IP}#$VIRTUALSERVER_IP#g" $NGINX_CONF_FILE
                perl -pi -e "s#{HOME}#$VIRTUALSERVER_HOME#g" $NGINX_CONF_FILE
                ln -s $NGINX_CONF_FILE /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}.conf
		        if [ "${VIRTUALSERVER_SSL}" = "1" ];
		        then
		                cp /etc/nginx/sites-available/template_ssl.conf $NGINX_SSL_CONF_FILE
		                perl -pi -e "s#{DOM}#$VIRTUALSERVER_DOM#g" $NGINX_SSL_CONF_FILE
		                perl -pi -e "s#{SITE_IP}#$VIRTUALSERVER_IP#g" $NGINX_SSL_CONF_FILE
		                perl -pi -e "s#{HOME}#$VIRTUALSERVER_HOME#g" $NGINX_SSL_CONF_FILE
		                ln -s $NGINX_SSL_CONF_FILE /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}_ssl.conf
		        fi
                /etc/init.d/nginx reload
        fi


elif [ "$VIRTUALSERVER_ACTION" = "DELETE_DOMAIN" ]; then
        if [ "${VIRTUALSERVER_WEB}" = "1" ];
        then
	            rm /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}.conf
	            rm /etc/nginx/sites-available/${VIRTUALSERVER_DOM}.conf
	            rm /var/log/virtualmin/${VIRTUALSERVER_DOM}_nginx_*
		        if [ "${VIRTUALSERVER_SSL}" = "1" ];
		        then
		                rm /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}_ssl.conf
		                rm /etc/nginx/sites-available/${VIRTUALSERVER_DOM}_ssl.conf
		                rm /var/log/virtualmin/${VIRTUALSERVER_DOM}_nginx_ssl*
		        fi
	            /etc/init.d/nginx reload
        fi


elif [ "$VIRTUALSERVER_ACTION" = "MODIFY_DOMAIN" ]; then
        if [ "${VIRTUALSERVER_WEB}" = "1" ];
        then
                if [ ! -f $NGINX_CONF_FILE ]; then
                        cp /etc/nginx/sites-available/template.conf $NGINX_CONF_FILE
                        perl -pi -e "s#{DOM}#$VIRTUALSERVER_DOM#g" $NGINX_CONF_FILE
                        perl -pi -e "s#{SITE_IP}#$VIRTUALSERVER_IP#g" $NGINX_CONF_FILE
                        perl -pi -e "s#{HOME}#$VIRTUALSERVER_HOME#g" $NGINX_CONF_FILE
                        ln -s $NGINX_CONF_FILE /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}.conf
                fi
                if [ "${VIRTUALSERVER_SSL}" = "1" ]; then
	                if [ ! -f $NGINX_SSL_CONF_FILE ]; then
	                        cp /etc/nginx/sites-available/template_ssl.conf $NGINX_SSL_CONF_FILE
	                        perl -pi -e "s#{DOM}#$VIRTUALSERVER_DOM#g" $NGINX_SSL_CONF_FILE
	                        perl -pi -e "s#{SITE_IP}#$VIRTUALSERVER_IP#g" $NGINX_SSL_CONF_FILE
	                        perl -pi -e "s#{HOME}#$VIRTUALSERVER_HOME#g" $NGINX_SSL_CONF_FILE
	                        ln -s $NGINX_SSL_CONF_FILE /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}_ssl.conf
	                fi
                fi
        fi

            if [ "$VIRTUALSERVER_DOM" != "$VIRTUALSERVER_OLDSERVER_DOM" ]; then
                if [ "${VIRTUALSERVER_WEB}" = "1" ];
                then
                        OLD_NGINX_CONF_FILE=/etc/nginx/sites-available/${VIRTUALSERVER_OLDSERVER_DOM}.conf
                        mv $OLD_NGINX_CONF_FILE $NGINX_CONF_FILE
                        rm /etc/nginx/sites-enabled/${VIRTUALSERVER_OLDSERVER_DOM}.conf
                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_DOM#$VIRTUALSERVER_DOM#g" $NGINX_CONF_FILE
                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_IP#$VIRTUALSERVER_IP#g" $NGINX_CONF_FILE
                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_HOME#$VIRTUALSERVER_HOME#g" $NGINX_CONF_FILE
                        ln -s /etc/nginx/sites-available/${VIRTUALSERVER_DOM}.conf /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}.conf
                        if [ "${VIRTUALSERVER_SSL}" = "1" ]; then
	                        OLD_NGINX_SSL_CONF_FILE=/etc/nginx/sites-available/${VIRTUALSERVER_OLDSERVER_DOM}_ssl.conf
	                        mv $OLD_NGINX_SSL_CONF_FILE $NGINX_SSL_CONF_FILE
	                        rm /etc/nginx/sites-enabled/${VIRTUALSERVER_OLDSERVER_DOM}_ssl.conf
	                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_DOM#$VIRTUALSERVER_DOM#g" $NGINX_SSL_CONF_FILE
	                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_IP#$VIRTUALSERVER_IP#g" $NGINX_SSL_CONF_FILE
	                        perl -pi -e "s#$VIRTUALSERVER_OLDSERVER_HOME#$VIRTUALSERVER_HOME#g" $NGINX_SSL_CONF_FILE
	                        ln -s /etc/nginx/sites-available/${VIRTUALSERVER_DOM}_ssl.conf /etc/nginx/sites-enabled/${VIRTUALSERVER_DOM}_ssl.conf
                        fi
                fi
            fi

        if [ "${VIRTUALSERVER_WEB}" = "1" ];
        then
                /etc/init.d/nginx reload
        fi
fi

