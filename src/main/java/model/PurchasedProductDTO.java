package model;

public class PurchasedProductDTO extends ProductDTO{
	private String purchased_date;
	private String order_id;
	private String status_name;

	public String getPurchased_date() {
		return purchased_date;
	}

	public void setPurchased_date(String purchased_date) {
		this.purchased_date = purchased_date;
	}

	public String getOrder_id() {
		return order_id;
	}

	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}

	public String getStatus_name() {
		return status_name;
	}

	public void setStatus_name(String status_name) {
		this.status_name = status_name;
	}
}
