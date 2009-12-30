<!--

BigBlueButton - http://www.bigbluebutton.org

Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.

BigBlueButton is free software; you can redistribute it and/or modify it under the 
terms of the GNU Lesser General Public License as published by the Free Software 
Foundation; either version 3 of the License, or (at your option) any later 
version. 

BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.

Author: Fred Dixon <ffdixon@bigbluebutton.org>

-->

<%@ page
	import="java.util.*,java.io.*,java.net.*,javax.crypto.*,javax.xml.parsers.*,org.w3c.dom.Document,org.xml.sax.*"
	errorPage="/error.jsp"%>

<%@ page import="org.apache.commons.codec.digest.*"%>


<%!

String salt = "639259d4-9dd8-4b25-bf01-95f9567eaf4b";
String BigBlueButtonURL = "http://192.168.0.154/bigbluebutton/";


public String getURL(String name, String meetingID) {

		String checksum = "";

		String base_main = "name=" + name + "&meetingID=" + meetingID
				+ "&attendeePW=ap&moderatorPW=mp";

		String base_create = BigBlueButtonURL + "api/create?";
		String base_join = BigBlueButtonURL + "api/join?";

		try {
			checksum = DigestUtils.shaHex(base_main + salt);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Attempt to create a meeting of that name
		String xml = getURL(base_create + base_main + "&checksum=" + checksum);

		Document doc = null;
		try {
			doc = parseXml(xml);
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (doc.getElementsByTagName("returncode").item(0).getTextContent()
				.trim().equals("SUCCESS")) {

			String meetingToken = "";

			if (doc.getElementsByTagName("meetingToken").item(0) != null) {
				meetingToken = doc.getElementsByTagName("meetingToken").item(0)
						.getTextContent().trim();
			}

			String main = "meetingToken=" + meetingToken + "&fullName=" + name
					+ "&password=mp";
			//System.out.println(base_join + main + "&checksum=" + checksum(main+salt));

			return base_join + main + "&checksum=" + checksum(main + salt);

		}
		return "";
	}

	public static String checksum(String s) {
		String checksum = "";
		try {
			checksum = DigestUtils.shaHex(s);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return checksum;
	}

	public static String getURL(String url) {
		StringBuffer response = null;

		// Verify that the communication will be over SSL.
		if (!url.startsWith("http")) {
			// throw new MalformedURLException("getURL(): URL \"" + url +
			// "\" does not use HTTPS.");
		}

		try {
			URL u = new URL(url);
			HttpURLConnection httpConnection = (HttpURLConnection) u
					.openConnection();

			httpConnection.setUseCaches(false);
			httpConnection.setDoOutput(true);
			httpConnection.setRequestMethod("GET");

			httpConnection.connect();
			int responseCode = httpConnection.getResponseCode();
			if (responseCode == HttpURLConnection.HTTP_OK) {
				InputStream input = httpConnection.getInputStream();

				// Read server's response.
				response = new StringBuffer();
				Reader reader = new InputStreamReader(input, "UTF-8");
				reader = new BufferedReader(reader);
				char[] buffer = new char[1024];
				for (int n = 0; n >= 0;) {
					n = reader.read(buffer, 0, buffer.length);
					if (n > 0)
						response.append(buffer, 0, n);
				}

				input.close();
				httpConnection.disconnect();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (response != null) {
			return response.toString();
		} else {
			return "";
		}
	}

	public static Document parseXml(String xml)
			throws ParserConfigurationException, IOException, SAXException {
		DocumentBuilderFactory docFactory = DocumentBuilderFactory
				.newInstance();
		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.parse(new InputSource(new StringReader(xml)));
		return doc;
	}%>