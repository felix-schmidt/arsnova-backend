package de.thm.arsnova.entities;

public class Attachment {

	private String type;
	private boolean stub; 
	private int length;
	private String digest;
	private int revpos;
	private String content_type;

	public Attachment() {
		this.setType("Attachment");
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean isStub() {
		return stub;
	}

	public void setStub(boolean stub) {
		this.stub = stub;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public String getDigest() {
		return digest;
	}

	public void setDigest(String digest) {
		this.digest = digest;
	}

	public String getContent_type() {
		return content_type;
	}

	public void setContent_type(String content_type) {
		this.content_type = content_type;
	}

	public int getRevpos() {
		return revpos;
	}

	public void setRevpos(int revpos) {
		this.revpos = revpos;
	}
}
