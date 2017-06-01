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

public class FeedReader.article : GLib.Object {

	private string m_articleID;
	private string m_title;
	private string m_url;
	private string m_html;
	private string m_preview;
	private string m_feedID;
	private Gee.ArrayList<string> m_tags;
	private Gee.ArrayList<string> m_media;
	private string? m_author;
	private ArticleStatus m_unread;
	private ArticleStatus m_marked;
	private int m_sortID;
	private GLib.DateTime m_date;
	private string m_guidHash;
	private int m_lastModified;
	private int m_pos;



	public article (	string articleID,
						string title,
						string url,
						string feedID,
						ArticleStatus unread,
						ArticleStatus marked,
						string html,
						string preview,
						string? author,
						GLib.DateTime date,
						int sortID,
						string tags,
						string media,
						string guidHash = "",
						int lastModified = 0)
	{
		m_articleID = articleID;
		m_title = title;
		m_url = url;
		m_html = html;
		m_preview = preview;
		m_feedID = feedID;
		m_author = author;
		m_unread = unread;
		m_marked = marked;
		m_sortID = sortID;
		m_date = date;
		m_guidHash = guidHash;
		m_lastModified = lastModified;

		m_tags = new Gee.ArrayList<string>();
		var tagArray = tags.split(",");
		foreach(string tag in tagArray)
		{
			if(tag.strip() != "")
				m_tags.add(tag);
		}

		m_media = new Gee.ArrayList<string>();
		var mediaArray = media.split(",");
		foreach(string m in mediaArray)
		{
			if(m.strip() != "")
				m_media.add(m);
		}
	}

	public string getArticleID()
	{
		return m_articleID;
	}

	public string getTitle()
	{
		return m_title;
	}

	public void setTitle(string title)
	{
		m_title = title;
	}

	public string getHTML()
	{
		return m_html;
	}

	public void setHTML(string html)
	{
		m_html = html;
	}

	public string getPreview()
	{
		return m_preview;
	}

	public void setPreview(string preview)
	{
		m_preview = preview;
	}

	public string? getAuthor()
	{
		return m_author;
	}

	public void setAuthor(string? author)
	{
		m_author = author;
	}

	public string getURL()
	{
		return m_url;
	}

	public int getSortID()
	{
		return m_sortID;
	}

	public GLib.DateTime getDate()
	{
		return m_date;
	}

	public string getDateNice(bool addTime = false)
	{
		var now = new GLib.DateTime.now_local();
		var now_year = now.get_year();
		var now_day = now.get_day_of_year();
		var now_week = now.get_week_of_year();

		var date_year = m_date.get_year();
		var date_day = m_date.get_day_of_year();
		var date_week = m_date.get_week_of_year();

		string time = (addTime) ? ", %H:%M" : "";

		if(date_year == 1900)
		{
			//return _("no date available");
		}
		else if(date_year == now_year)
		{
			if(date_day == now_day)
			{
				return m_date.format("%H:%M");
			}
			else if(date_day == now_day-1)
			{
				return _("Yesterday") + m_date.format(", %H:%M");
			}
			else if(date_week == now_week)
			{
				return m_date.format("%A" + time);
			}
			else
			{
				return m_date.format("%B %d" + time);
			}
		}

		return m_date.format("%Y-%m-%d" + time);
	}

	public string getFeedID()
	{
		return m_feedID;
	}

	public ArticleStatus getUnread()
	{
		return m_unread;
	}

	public void setUnread(ArticleStatus unread)
	{
		m_unread = unread;
	}

	public ArticleStatus getMarked()
	{
		return m_marked;
	}

	public void setMarked(ArticleStatus marked)
	{
		m_marked = marked;
	}

	public unowned Gee.ArrayList<string> getTags()
	{
		return m_tags;
	}

	public string getTagString()
	{
		string tags = "";
		foreach(string tag in m_tags)
		{
			tags += tag + ",";
		}
		return tags;
	}

	public void setTags(Gee.ArrayList<string> tags)
	{
		m_tags = tags;
	}

	public void addTag(string tag)
	{
		if(!m_tags.contains(tag))
			m_tags.add(tag);
	}

	public unowned Gee.ArrayList<string> getMedia()
	{
		return m_media;
	}

	public string getMediaString()
	{
		string media = "";
		foreach(string m in m_media)
		{
			media += m + ",";
		}
		return media;
	}

	public void setMedia(Gee.ArrayList<string> media)
	{
		m_media = media;
	}

	public void addMedia(string m)
	{
		if(!m_media.contains(m))
			m_media.add(m);
	}

	public bool haveMedia()
	{
		if(m_media.size > 0)
			return true;

		return false;
	}

	public string getHash()
	{
		return m_guidHash;
	}

	public int getLastModified()
	{
		return m_lastModified;
	}

	public int getPos()
	{
		return m_pos;
	}

	public void setPos(int pos)
	{
		m_pos = pos;
	}
}
