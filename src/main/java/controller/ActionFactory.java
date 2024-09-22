package controller;

public class ActionFactory {
	private static ActionFactory instance = new ActionFactory();
    
    private ActionFactory() {
        // private constructor to prevent instantiation
    }

    public static ActionFactory getInstance() {
        return instance;
    }
    
    public Action getAction(String action) {
        if (action.equals("productList")) {
            return new ProductListAction();
        }
        else if (action.equals("product")) {
        	return new productAction();
        }
        else if (action.equals("basket")) {
        	return new basketAction();
        }
        else if (action.equals("basketDeletion")) {
        	return new basketDeletionAction();
        }
        else if (action.equals("basketInsertion")) {
        	return new basketInsertionAction();
        }
        else if (action.equals("readyToPurchase")) {
        	return new readyToPurchaseAction();
        }
        else if (action.equals("purchase")) {
        	return new purchaseAction();
        }
        else if (action.equals("purchasedList")) {
        	return new purchasedListAction();
        }
        else if (action.equals("purchasedProductList")) {
        	return new purchasedProductListAction();
        }
        else if (action.equals("purchasedProduct")) {
        	return new purchasedProductAction();
        }
        return null;
    }
}
