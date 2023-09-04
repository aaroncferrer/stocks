import axios from 'axios';
import './tableModal.css'
import Modal from 'react-bootstrap/Modal'

function TableModal(props) {
    const { currentUser, setCurrentUser, table_header, showStockModal, setShowStockModal, stockData, showTraderModal, setShowTraderModal, traderData, updateTrader, setPortfolioUpdated } = props;

    const handleSubmitBuy = async (e) => {
        e.preventDefault();
        
        const stockSymbol = stockData.symbol; 
        const quantity = e.target.quantity.value;
        const totalPrice = quantity * stockData.price_amount;

        try {
            const token = currentUser.token;
            await axios.post('http://localhost:3000/buy', 
            {
                stock_symbol: stockSymbol,
                quantity: quantity,
            }, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            setCurrentUser({ ...currentUser, balance: currentUser.balance - (totalPrice) });
            alert("Stock successfully bought!");
            setShowStockModal(false);
        } catch (error) {
            alert(error.response.data.error);
        }
    };

    const handleSubmitSell = async (e) => {
        e.preventDefault();
        
        const stockSymbol = stockData.symbol; 
        const quantity = e.target.quantity.value;
        const totalPrice = quantity * stockData.price_amount;

        try {
            const token = currentUser.token;
            const response = await axios.post('http://localhost:3000/sell', 
            {
                stock_symbol: stockSymbol,
                quantity: quantity,
            }, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            const data = response.data;
            console.log(data);
            setPortfolioUpdated(true);
            setCurrentUser({ ...currentUser, balance: currentUser.balance + (totalPrice) });   
            alert("Stock successfully sold!");
            setShowStockModal(false);
        } catch (error) {
            alert(error.response.data.error);
        }
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        const updatedData = {
            first_name: e.target.first_name.value,
            last_name: e.target.last_name.value,
            email: e.target.email.value,
            status: e.target.status.value,
        };
        updateTrader(traderData.id, updatedData);
    };

    return(
        <>             
            {/* STOCK MODAL */}
            <Modal show={showStockModal} onHide={() => setShowStockModal(false)} className='modal'>
                {stockData ? (
                    <>
                    <Modal.Header closeButton className=''>
                        <h2>Stock Details</h2>
                    </Modal.Header>
                    <Modal.Body className='modal_body'>
                        <p>{stockData.name}</p>
                        <p>{stockData.symbol}</p>
                        <p>{stockData.price_amount} {stockData.price_currency}</p>
                        <p>{stockData.percent_change}</p>
                        <p>As of: {new Date(stockData.as_of).toLocaleString()}</p>
                        {currentUser.role === "trader" && (
                            <form onSubmit={table_header === "PORTFOLIOS" ? handleSubmitSell : handleSubmitBuy}>
                                <div className="buy_container">
                                    <p>{table_header === "PORTFOLIOS" ? "SELL :" : "BUY :"}</p>
                                    <input
                                        style={{display: "block", margin: "0.75rem 0rem"}}
                                        type='number'
                                        name='quantity'
                                        placeholder='Enter quantity'
                                        required

                                    />
                                    <button type='submit' className='btns btn_primary'>Submit</button>
                                </div>
                            </form>
                        )}
                    </Modal.Body>
                    <Modal.Footer>
                        <button className='btns btn_secondary' onClick={() => setShowStockModal(false)}>
                            Close
                        </button>
                    </Modal.Footer>
                    </>
                ) : (
                    <p>Loading Stock Details</p>
                )}
            </Modal>
            
            {/* TRADER MODAL */}
            <Modal show={showTraderModal} onHide={() => setShowTraderModal(false)} className='modal'>
                {traderData ? (
                    <>
                    <Modal.Header closeButton className=''>
                        <h2>Trader Details</h2>
                    </Modal.Header>
                    <form onSubmit={handleSubmit}>
                    <Modal.Body className='modal_body'>
                        <input
                            type="text"
                            name="first_name"
                            defaultValue={traderData.first_name}
                        />
                        <input
                            type="text"
                            name="last_name"
                            defaultValue={traderData.last_name}
                        />
                        <input
                            type="text"
                            name="email"
                            defaultValue={traderData.email}
                        />
                        <input
                            type="text"
                            name="status"
                            defaultValue={traderData.status}
                        />
                        <p>Balance: {traderData.balance}</p>
                        <p>Date joined: {new Date(traderData.created_at).toLocaleString()}</p>
                        <p>Date approved: {traderData.status === "pending" ? "N/A" : new Date(traderData.confirmed_at).toLocaleString()}</p>
                        <button className='btns btn_primary'>Submit</button>
                    </Modal.Body>
                    </form>
                    <Modal.Footer>
                        <button className='btns btn_secondary' onClick={() => setShowTraderModal(false)}>
                            Close
                        </button>
                    </Modal.Footer>
                    </>
                ) : (
                    <p>Loading Trader Details</p>
                )}
            </Modal>
        </>
    )
}

export default TableModal;