# =============================================================================
# Odoo 19 Community + módulos Siteco — imagen de producción (cliente: Imperio Real)
# =============================================================================
# Contiene módulos OPL-1: publicar SOLO como paquete privado.
#
#   docker build --platform linux/amd64 -t ghcr.io/juanca2918/odoo19-ce:siteco-odoo-v1.0 .
#   docker push ghcr.io/juanca2918/odoo19-ce:siteco-odoo-v1.0
#
# Sin secretos: las credenciales llegan por variables (ver docker-compose.yml).
# =============================================================================
FROM odoo:19.0-20261102

USER root

# Dependencia de base_accounting_kit que no trae la imagen oficial.
RUN pip3 install --break-system-packages --no-cache-dir qifparse==0.5

COPY docker/odoo.conf /etc/odoo/odoo.conf

# No usar /mnt/extra-addons: es VOLUME en la imagen base y Compose conserva los
# volúmenes anónimos al recrear, así que una imagen nueva seguiría con módulos viejos.
COPY custom_addons /opt/siteco-addons

# Precompilar: el código es de root y Odoo (usuario odoo) no puede escribir los .pyc.
RUN python3 -m compileall -q /opt/siteco-addons > /dev/null

USER odoo
