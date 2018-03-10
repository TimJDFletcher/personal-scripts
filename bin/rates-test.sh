#!/bin/bash
curl -sLkv -X POST http://$1/api/htng2014b  \
	-H 'TCPTrace: eer5yahnguGezer0' \
	-H 'Host: rates-query.prod.laterooms.io' \
	-H 'cache-control: no-cache' \
	-H 'content-type: application/xml' \
	-d '<OTA_HotelRatePlanRQ EchoToken="e3ec4b6a-5e91-493f-82a4-17f2944dad74" TimeStamp="2017-05-09T08:31:43.544Z" Version="3.000" xmlns="http://www.opentravel.org/OTA/2003/05">
  <POS>
    <Source>
      <RequestorID Type="55" ID="Siteminder"/>
    </Source>
  </POS>
  <RatePlans>
    <RatePlan>
      <HotelRef HotelCode="189834"/>
    </RatePlan>
  </RatePlans>
</OTA_HotelRatePlanRQ>'
