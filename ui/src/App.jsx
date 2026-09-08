import { useEffect, useState } from "react";

function App() {
  const [products, setProducts] = useState([]);
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");
  const [status, setStatus] = useState("Checking...");

  const loadProducts = async () => {
    try {
      const response = await fetch("/api/products");

      if (!response.ok) {
        throw new Error("API request failed");
      }

      const data = await response.json();
      setProducts(data);
    } catch (error) {
      console.error(error);
    }
  };

  const checkHealth = async () => {
    try {
      const response = await fetch("/api/health");

      if (!response.ok) {
        throw new Error("API unavailable");
      }

      const data = await response.json();

      setStatus(
        data.status === "healthy"
          ? "Healthy - Database Connected"
          : "Unhealthy"
      );
    } catch (error) {
      setStatus("API Unavailable");
    }
  };

  useEffect(() => {
    loadProducts();
    checkHealth();
  }, []);

  const addProduct = async (event) => {
    event.preventDefault();

    if (!name || !price) {
      alert("Please enter product name and price");
      return;
    }

    try {
      const response = await fetch("/api/products", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          name,
          price: Number(price)
        })
      });

      if (!response.ok) {
        throw new Error("Failed to add product");
      }

      setName("");
      setPrice("");

      await loadProducts();
    } catch (error) {
      alert(error.message);
    }
  };

  return (
    <div
      style={{
        maxWidth: "700px",
        margin: "50px auto",
        padding: "20px",
        fontFamily: "Arial, sans-serif"
      }}
    >
      <h1>AKS Product Management</h1>

      <p>
        API Status: <strong>{status}</strong>
      </p>

      <hr />

      <h2>Add Product</h2>

      <form onSubmit={addProduct}>
        <div style={{ marginBottom: "15px" }}>
          <label>Product Name</label>

          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Laptop"
            style={{
              display: "block",
              width: "100%",
              padding: "10px",
              marginTop: "5px",
              boxSizing: "border-box"
            }}
          />
        </div>

        <div style={{ marginBottom: "15px" }}>
          <label>Price</label>

          <input
            type="number"
            value={price}
            onChange={(e) => setPrice(e.target.value)}
            placeholder="65000"
            style={{
              display: "block",
              width: "100%",
              padding: "10px",
              marginTop: "5px",
              boxSizing: "border-box"
            }}
          />
        </div>

        <button
          type="submit"
          style={{
            padding: "10px 20px",
            cursor: "pointer"
          }}
        >
          Add Product
        </button>
      </form>

      <hr />

      <h2>Products</h2>

      {products.length === 0 ? (
        <p>No products found.</p>
      ) : (
        products.map((product) => (
          <div
            key={product.id}
            style={{
              border: "1px solid #ddd",
              padding: "12px",
              marginBottom: "10px"
            }}
          >
            <strong>{product.name}</strong>

            <div>₹{product.price}</div>
          </div>
        ))
      )}
    </div>
  );
}

export default App;