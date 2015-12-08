FROM java:8-jre

RUN ls
RUN curl -vL -o /oba.war 'http://nexus.onebusaway.org/service/local/artifact/maven/content?r=public&g=org.onebusaway&a=onebusaway-quickstart-assembly&c=webapp&e=war&v=1.1.14'

ADD bundle.xml /bundle.xml
ADD gtfs.zip /gtfs.zip

RUN ls /
RUN ls /oba.war

RUN java -Xmx1G -server -jar /oba.war -build /bundle.xml /gtfs-bundle \
    -P tripEntriesFactory.throwExceptionOnInvalidStopToShapeMappingException=false \
    -P distanceAlongShapeLibrary.localMinimumThreshold=50 \
    -P distanceAlongShapeLibrary.maxDistanceFromStopToShapePoint=1000

CMD java -Xmx1G -server -jar /oba.war -webapp \
    -gtfsRealtimeAlertsUrl="https://data.texas.gov/download/nusn-7fcn/application/octet-stream" \
    -gtfsRealtimeTripUpdatesUrl="https://data.texas.gov/download/rmk2-acnw/application/octet-stream" \
    -gtfsRealtimeVehiclePositionsUrl="https://data.texas.gov/download/eiei-9rpf/application/octet-stream" \
    gtfs-bundle
