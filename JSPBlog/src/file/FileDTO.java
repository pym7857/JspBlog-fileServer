package file;

public class FileDTO {
	
	String fileName;
	String fileRealName;
	int downloadCount;
	String fileDate;
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileRealName() {
		return fileRealName;
	}
	public void setFileRealName(String fileRealName) {
		this.fileRealName = fileRealName;
	}
	public int getDownloadCount() {
		return downloadCount;
	}
	public void setDownloadCount(int downloadCount) {
		this.downloadCount = downloadCount;
	}
	public String getFileDate() {
		return fileDate;
	}
	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}
	public FileDTO(String fileName, String fileRealName, int downloadCount, String fileDate) {
		super();
		this.fileName = fileName;
		this.fileRealName = fileRealName;
		this.downloadCount = downloadCount;
		this.fileDate = fileDate;
	}
}
