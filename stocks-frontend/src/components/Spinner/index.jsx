import './spinner.css'

function Spinner() {
    return (
        <div className="spinner-overlay">
            <div className="spinner_container">
                <h1>Loading Stocks</h1>
                <div className="custom-loader"></div>
            </div>
        </div>
    );
}

export default Spinner;
