import './tableModal.css'
import Modal from 'react-bootstrap/Modal'

function TableModal(props) {
    const { showStockModal, setShowStockModal, stockData, showTraderModal, setShowTraderModal, traderData, updateTrader } = props;

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
                        <button>Submit</button>
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