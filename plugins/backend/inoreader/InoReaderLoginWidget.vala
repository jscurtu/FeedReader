//	This file is part of FeedReader.
//
//	FeedReader is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	FeedReader is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with FeedReader.  If not, see <http://www.gnu.org/licenses/>.

public class FeedReader.InoReaderLoginWidget : Peas.ExtensionBase, LoginInterface {

	private InoReaderUtils m_utils;

	public void init()
	{
		m_utils = new InoReaderUtils();
	}

	public string getWebsite()
	{
		return "http://www.inoreader.com/";
	}

	public BackendFlags getFlags()
	{
		return (BackendFlags.HOSTED | BackendFlags.PROPRIETARY | BackendFlags.PAID_PREMIUM);
	}

	public string getID()
	{
		return "inoreader";
	}

	public string iconName()
	{
		return "feed-service-inoreader";
	}

	public string serviceName()
	{
		return "InoReader";
	}

	public void writeData()
	{
		return;
	}

	public async void postLoginAction()
	{
		return;
	}

	public bool extractCode(string redirectURL)
	{
		if(redirectURL.has_prefix(InoReaderSecret.apiRedirectUri))
		{
			Logger.debug(redirectURL);
			int csrf_start = redirectURL.index_of("state=")+6;
			string csrf_code = redirectURL.substring(csrf_start);
			Logger.debug("InoReaderLoginWidget: csrf_code: " + csrf_code);

			if(csrf_code == InoReaderSecret.csrf_protection)
			{
				int start = redirectURL.index_of("code=")+5;
				int end = redirectURL.index_of("&", start);
				string code = redirectURL.substring(start, end-start);
				m_utils.setApiCode(code);
				Logger.debug("InoReaderLoginWidget: set inoreader-api-code: " + code);
				GLib.Thread.usleep(500000);
				return true;
			}

			Logger.error("InoReaderLoginWidget: csrf_code mismatch");
		}
		else
		{
			Logger.warning("InoReaderLoginWidget: wrong redirect_uri: " + redirectURL);
		}

		return false;
	}

	public string buildLoginURL()
	{
		return "https://www.inoreader.com/oauth2/auth"
			+ "?client_id=" + InoReaderSecret.apiClientId
			+ "&redirect_uri=" + InoReaderSecret.apiRedirectUri
			+ "&response_type=code"
			+ "&scope=read+write"
			+ "&state=" + InoReaderSecret.csrf_protection;
	}

	public bool needWebLogin()
	{
		return true;
	}

	public Gtk.Box? getWidget()
	{
		return null;
	}

	public void showHtAccess()
	{
		return;
	}
}

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
	var objmodule = module as Peas.ObjectModule;
	objmodule.register_extension_type(typeof(FeedReader.LoginInterface), typeof(FeedReader.InoReaderLoginWidget));
}
