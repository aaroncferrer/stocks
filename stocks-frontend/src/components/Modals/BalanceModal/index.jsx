import Modal from 'react-bootstrap/Modal'

function BalanceModal(props) {
    const { showWithdrawModal, setShowWithdrawModal, showDepositModal, setShowDepositModal,depositAmount, setDepositAmount, withdrawAmount, setWithdrawAmount, handleDeposit, handleWithdraw } = props;

    return(
        <>
            <Modal show={showWithdrawModal} onHide={() => setShowWithdrawModal(false)} className='modal'>
                    <>
                    <Modal.Header closeButton className=''>
                        <h2>Manage funds</h2>
                    </Modal.Header>
                    <form onSubmit={handleWithdraw}>
                    <Modal.Body className='modal_body'>
                        <h5>WITHDRAW</h5>
                        <input 
                            type='number'
                            value={withdrawAmount}
                            onChange={(e) => setWithdrawAmount(parseFloat(e.target.value))}
                        />
                    </Modal.Body>
                    <Modal.Footer>
                        <button type="submit" className='btns btn_secondary' >Submit</button>
                    </Modal.Footer>
                    </form>
                    </>
            </Modal>

            <Modal show={showDepositModal} onHide={() => setShowDepositModal(false)} className='modal'>
                    <>
                    <Modal.Header closeButton className=''>
                        <h2>Manage funds</h2>
                    </Modal.Header>
                    <form onSubmit={handleDeposit}>
                    <Modal.Body className='modal_body'>
                        <h5>DEPOSIT</h5>
                        <input 
                            type='number'
                            value={depositAmount}
                            onChange={(e) => setDepositAmount(parseFloat(e.target.value))}
                        />
                    </Modal.Body>
                    <Modal.Footer>
                        <button type="submit" className='btns btn_secondary' >Submit</button>
                    </Modal.Footer>
                    </form>
                    </>
            </Modal>
        </>
    )
}

export default BalanceModal;