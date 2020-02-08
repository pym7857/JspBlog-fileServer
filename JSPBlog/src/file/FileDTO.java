package file;

public class FileDTO {
	
	String fileName;
	String fileRealName;
	int downloadCount;
	String fileDate;
	String fileType;
	String fileSize;
	String uploadUserID;
	
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
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getUploadUserID() {
		return uploadUserID;
	}
	public void setUploadUserID(String uploadUserID) {
		this.uploadUserID = uploadUserID;
	}
	public FileDTO() {
		super();
	}
	public FileDTO(String fileName, String fileRealName, int downloadCount, String fileDate, String fileType, String fileSize, String uploadUserID) {
		super();
		this.fileName = fileName;
		this.fileRealName = fileRealName;
		this.downloadCount = downloadCount;
		this.fileDate = fileDate;
		this.fileType = fileType;
		this.fileSize = fileSize;
		this.uploadUserID = uploadUserID;
	}
}
