package model;


public class ProductDTO {
	private String id = null;
    private String name = null;
    private double price = Integer.MIN_VALUE;
    private String detail = null;
    private String published_date = null;
    private String publisher = null;
    private String product_image = null;
    private String author = null;

    // Getters and setters
    public String getId() {
		return id;
	}

	public void setId(String i) {
		this.id = i;
	}
    
    public String getName() {
        return name;
    }

	public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public String getPublished_date() {
		return published_date;
	}

	public void setPublished_date(String published_date) {
		this.published_date = published_date;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getProduct_image() {
		return product_image;
	}

	public void setProduct_image(String product_image) {
		this.product_image = product_image;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}
	
	public void set(ProductDTO p) {
		if(this.id== null) this.id = p.id;
		if(this.name== null) this.name = p.name;
		if(this.price == Integer.MIN_VALUE) this.price = p.price;
		if(this.detail== null) this.detail = p.detail;
		if(this.published_date== null) this.published_date = p.published_date;
		if(this.publisher== null) this.publisher = p.publisher;
	}
}

